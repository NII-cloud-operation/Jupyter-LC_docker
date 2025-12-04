"""Playwright utility helpers.

Copied from https://github.com/RCOSDP/RDM-e2e-test-nb (scripts/playwright.py)
commit dda7a5de4336c3c3a79537f1537de7d65a0034e6 with minimal path adjustments
for lc_docker.
"""

from datetime import datetime
import os
import shutil
import sys
import tempfile
import time
import traceback

from IPython.display import Image
from playwright.async_api import async_playwright, expect

playwright = None
current_session_id = None
current_browser = None
current_contexts = None
default_last_path = None
context_close_on_fail = True
temp_dir = None


async def run_pw(
    f,
    last_path=default_last_path,
    screenshot=True,
    permissions=None,
    new_context=False,
    new_page=False,
):
    global current_browser
    if current_browser is None:
        current_browser = await playwright.chromium.launch(
            headless=True,
            args=["--no-sandbox", "--disable-dev-shm-usage", "--lang=ja"],
        )

    global current_contexts
    if current_contexts is None or len(current_contexts) == 0 or new_context:
        videos_dir = os.path.join(temp_dir, "videos/")
        os.makedirs(videos_dir, exist_ok=True)
        har_path = os.path.join(temp_dir, "har.zip")

        context = await current_browser.new_context(
            locale="ja-JP",
            record_video_dir=videos_dir,
            record_har_path=har_path,
        )
        if current_contexts is None:
            current_contexts = [(context, [])]
        else:
            current_contexts.append((context, []))

    current_context, current_pages = current_contexts[-1]
    if len(current_pages) == 0 or new_page:
        current_pages.append(await current_context.new_page())

    current_time = time.time()
    print(f"Start epoch: {current_time} seconds")
    if permissions is not None:
        await current_context.grant_permissions(permissions)
    next_page = None
    if f is not None:
        try:
            next_page = await f(current_pages[-1])
        except Exception:
            if context_close_on_fail:
                await finish_pw_context(screenshot=screenshot, last_path=last_path)
                raise
            if screenshot:
                await _save_screenshot()
            raise
    if next_page is not None:
        current_pages.append(next_page)
    screenshot_path = os.path.join(temp_dir, "screenshot.png")
    await current_pages[-1].screenshot(path=screenshot_path)
    return Image(screenshot_path)


async def close_latest_page(last_path=None):
    global current_contexts
    if current_contexts is None or len(current_contexts) == 0:
        raise Exception("No contexts")
    current_context, current_pages = current_contexts[-1]
    if len(current_contexts) <= 1 and len(current_pages) <= 1:
        raise Exception(
            "It is only possible to close when two or more contexts or pages are stacked"
        )
    os.makedirs(last_path or default_last_path, exist_ok=True)
    last_page = current_pages[-1]
    if last_page in current_pages[:-1] or any(
        last_page in pages for _, pages in current_contexts[:-1]
    ):
        assert len(current_pages) > 0, current_pages
        current_contexts[-1] = (current_context, current_pages[:-1])
        return
    video_path = await last_page.video.path()
    index = len(current_pages)
    dest_video_path = os.path.join(last_path or default_last_path, f"video-{index}.webm")
    shutil.copyfile(video_path, dest_video_path)
    current_pages = current_pages[:-1]
    current_contexts[-1] = (current_context, current_pages)
    await last_page.close()
    if len(current_pages) > 0:
        return
    current_contexts = current_contexts[:-1]
    await current_context.close()


async def init_pw_context(close_on_fail=True, last_path=None):
    global playwright
    global current_session_id
    global default_last_path
    global current_browser
    global temp_dir
    global context_close_on_fail
    global current_contexts
    if current_browser is not None:
        await current_browser.close()
        current_browser = None
    if playwright is not None:
        await playwright.stop()
        playwright = None
    playwright = await async_playwright().start()
    current_session_id = datetime.now().strftime("%Y%m%d-%H%M%S")
    default_last_path = last_path or os.path.join(
        os.path.expanduser("~/last-screenshots"), current_session_id
    )
    temp_dir = tempfile.mkdtemp()
    context_close_on_fail = close_on_fail
    if current_contexts is not None:
        for current_context in current_contexts:
            await current_context.close()
    current_contexts = None
    return (current_session_id, temp_dir)


async def finish_pw_context(screenshot=False, last_path=None):
    global current_browser
    await _finish_pw_context(screenshot=screenshot, last_path=last_path)
    if current_browser is not None:
        await current_browser.close()
        current_browser = None


async def save_screenshot(path):
    if current_contexts is None or len(current_contexts) == 0:
        raise Exception("No contexts")
    _, current_pages = current_contexts[-1]
    if current_pages is None or len(current_pages) == 0:
        raise Exception("Unexpected state")
    await current_pages[-1].screenshot(path=path)
    return path


async def _save_screenshot(last_path=None):
    if current_contexts is None or len(current_contexts) == 0:
        raise Exception("No contexts")
    _, current_pages = current_contexts[-1]
    os.makedirs(last_path or default_last_path, exist_ok=True)
    if current_pages is None or len(current_pages) == 0:
        return
    screenshot_path = os.path.join(temp_dir, "last-screenshot.png")
    await current_pages[-1].screenshot(path=screenshot_path)
    dest_screenshot_path = os.path.join(
        last_path or default_last_path, "last-screenshot.png"
    )
    shutil.copyfile(screenshot_path, dest_screenshot_path)
    print(f"Screenshot: {dest_screenshot_path}")


async def _finish_pw_context(screenshot=False, last_path=None):
    global current_contexts
    if current_contexts is None or len(current_contexts) == 0:
        return
    current_context, current_pages = current_contexts[-1]
    os.makedirs(last_path or default_last_path, exist_ok=True)
    timeout_on_screenshot = False
    if screenshot and current_pages is not None and len(current_pages) > 0:
        try:
            await _save_screenshot(last_path=last_path)
        except Exception:
            print("スクリーンショットの取得に失敗しました。", file=sys.stderr)
            traceback.print_exc()
            timeout_on_screenshot = True
    if timeout_on_screenshot:
        return
    current_contexts = current_contexts[::-1]
    await current_context.close()
    for i, current_page in enumerate(current_pages):
        index = i + 1
        try:
            video_path = await current_page.video.path()
            dest_video_path = os.path.join(
                last_path or default_last_path, f"video-{index}.webm"
            )
            shutil.copyfile(video_path, dest_video_path)
            print(f"Video: {dest_video_path}")
        except Exception:
            print("スクリーンキャプチャ動画の取得に失敗しました。", file=sys.stderr)
            traceback.print_exc()
            timeout_on_screenshot = True
    if timeout_on_screenshot:
        return
    har_path = os.path.join(temp_dir, "har.zip")
    dest_har_path = os.path.join(last_path or default_last_path, "har.zip")
    if os.path.exists(har_path):
        shutil.copyfile(har_path, dest_har_path)
        print(f"HAR: {dest_har_path}")
    else:
        print(".harファイルの取得に失敗しました。", file=sys.stderr)
    shutil.rmtree(temp_dir)
    for page in current_pages:
        await page.close()
    if len(current_contexts) == 0:
        return
    await _finish_pw_context(screenshot=False, last_path=last_path)


__all__ = [
    "async_playwright",
    "expect",
    "run_pw",
    "close_latest_page",
    "init_pw_context",
    "finish_pw_context",
    "save_screenshot",
]