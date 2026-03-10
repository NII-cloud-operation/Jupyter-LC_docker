"""Jupyter Notebook 7 utility helpers.

Helper functions for common Notebook 7 operations in e2e tests.
"""

from playwright.async_api import Page, Locator, expect
import re


async def create_new_notebook(
    page: Page,
    kernel: str = "Python 3",
    timeout: int = 30000
):
    """Create a new notebook with specified kernel from the tree page.

    Assumes page is already on the tree page (/tree).
    Returns the new page object for the created notebook (opens in new tab).

    Args:
        page: Playwright page object (must be on /tree page)
        kernel: Kernel type (default: "Python 3")
        timeout: Timeout in milliseconds

    Returns:
        Page object for the newly created notebook
    """
    # Wait for new page to open when clicking New button
    async with page.context.expect_page() as new_page_info:
        # Click the "New" dropdown button
        new_button = page.locator('.jp-DropdownMenu.jp-Toolbar-item[data-jp-item-name="new-dropdown"]')
        await expect(new_button).to_be_visible(timeout=timeout)
        await new_button.click()

        # Click on the kernel option in the dropdown
        dropdown_menu = page.locator('.lm-Menu.lm-MenuBar-menu')
        await expect(dropdown_menu).to_be_visible(timeout=timeout)
        kernel_option = dropdown_menu.locator('.lm-Menu-item[data-command="notebook:create-new"]').filter(has_text=re.compile(rf'^{re.escape(kernel)}$'))
        await expect(kernel_option).to_be_visible(timeout=timeout)
        await kernel_option.click()

    # Get the new page
    new_page = await new_page_info.value

    # Wait for the notebook to be ready (first cell visible)
    await expect(new_page.locator('.jp-Cell.jp-CodeCell')).to_be_visible(timeout=timeout)

    return new_page


async def set_cell_type(
    page: Page,
    index: int,
    cell_type: str,
    timeout: int = 30000
):
    """Change the type of a cell at the specified index.

    Similar to Galata's page.notebook.setCellType functionality.

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        cell_type: Cell type ("code" or "markdown")
        timeout: Timeout in milliseconds
    """
    # Get and select the cell
    cell = await get_cell(page, index, timeout)
    await select_cell(page, index, timeout)

    # Check current cell type
    class_name = await cell.get_attribute('class')
    current_cell_type = "code" if 'jp-CodeCell' in class_name else "markdown"

    # Not change if cell type is same
    if current_cell_type == cell_type:
        return

    # Click cell type toolbar item
    cell_type_toolbar_item = page.locator('.jp-Toolbar-item[data-jp-item-name="cellType"]')
    await cell_type_toolbar_item.click()

    # Change cell type
    selectInput = page.locator('div.jp-Notebook-toolbarCellTypeDropdown select')
    await expect(selectInput).to_be_visible(timeout=timeout)
    await selectInput.select_option(cell_type)


async def set_cell(
    page: Page,
    index: int,
    cell_type: str,
    content: str,
    timeout: int = 30000
):
    """Set the content of a cell at the specified index.

    Similar to Galata's page.notebook.setCell functionality.

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        cell_type: Cell type ("code" or "markdown")
        content: Content to set in the cell
        timeout: Timeout in milliseconds
    """
    # Get the cell
    cell = await get_cell(page, index, timeout)

    # Change cell type if needed
    await set_cell_type(page, index, cell_type, timeout)

    # Click the editor to focus it
    editor = cell.locator('.jp-Cell-inputArea')
    if cell_type == 'markdown':
        await editor.dblclick()
    await editor.click()

    # Clear existing content
    await page.keyboard.press('ControlOrMeta+A')
    await page.keyboard.press('Backspace')

    # Type new content
    # give CodeMirror time to style properly
    await page.keyboard.type(content, delay=100 if cell_type == 'code' else 0)

    # give CodeMirror time to style properly
    if cell_type == 'code':
        await page.wait_for_timeout(500)


async def run_cell(
    page: Page,
    index: int,
    wait_for_output: bool = True,
    timeout: int = 30000
):
    """Execute a cell at the specified index.

    Similar to Galata's page.notebook.runCell functionality.

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        wait_for_output: Wait for cell execution to complete (default: True)
        timeout: Timeout in milliseconds
    """
    # Get and select the cell
    cell = await get_cell(page, index, timeout)
    await select_cell(page, index, timeout)

    # Execute using Shift+Enter
    await page.keyboard.press('Shift+Enter')

    # Wait for execution to complete if requested
    if wait_for_output:
        # Wait for the cell to finish executing
        # The prompt changes from [*] (executing) to [n] (completed)
        prompt = cell.locator('.jp-InputArea-prompt')
        # Wait until the prompt doesn't contain [*]
        await expect(prompt).not_to_contain_text('[*]', timeout=timeout)


async def run(
    page: Page,
    timeout: int = 30000
):
    """Execute all cells in the notebook.

    Similar to Galata's page.notebook.run functionality.
    Uses menu click to trigger "Run All Cells" command.

    Args:
        page: Playwright page object
        timeout: Timeout in milliseconds
    """
    # Click the "Run" menu in the menu bar
    run_menu = page.locator('.lm-MenuBar-itemLabel').filter(has_text=re.compile(r'^Run$'))
    await expect(run_menu).to_be_visible(timeout=timeout)
    await run_menu.click()

    # Click "Run All Cells" in the dropdown menu
    dropdown_menu = page.locator('.lm-Menu.lm-MenuBar-menu')
    await expect(dropdown_menu).to_be_visible(timeout=timeout)
    run_all_item = dropdown_menu.locator('.lm-Menu-item[data-command="runmenu:run-all"]')
    await expect(run_all_item).to_be_visible(timeout=timeout)
    await run_all_item.click()

    # Wait for all cells to finish executing
    # Wait until there are no cells with [*] in their prompts
    cells = page.locator('.jp-Cell')
    cell_count = await cells.count()

    for i in range(cell_count):
        cell = cells.nth(i)
        # Check if it's a code cell
        class_name = await cell.get_attribute('class')
        if 'jp-CodeCell' in class_name:
            prompt = cell.locator('.jp-InputArea-prompt')
            # Wait until the prompt doesn't contain [*]
            await expect(prompt).not_to_contain_text('[*]', timeout=timeout)


async def add_cell(
    page: Page,
    cell_type: str,
    content: str,
    timeout: int = 30000
) -> int:
    """Add a new cell at the end of the notebook.

    Similar to Galata's page.notebook.addCell functionality.
    Selects the last cell and clicks the insert button in the toolbar.

    Args:
        page: Playwright page object
        cell_type: Cell type ("code" or "markdown")
        content: Cell content
        timeout: Timeout in milliseconds

    Returns:
        The index of the newly added cell
    """
    # Get all cells and select the last one
    cells = page.locator('.jp-Cell')
    cell_count = await cells.count()

    if cell_count > 0:
        # Select the last cell
        await select_cell(page, cell_count - 1, timeout)

    # Click the insert button in the toolbar
    insert_button = page.locator('.jp-Toolbar-item[data-jp-item-name="insert"]')
    await expect(insert_button).to_be_visible(timeout=timeout)
    await insert_button.click()

    # Wait for the new cell to be added
    new_cell_count = cell_count + 1
    await expect(cells).to_have_count(new_cell_count, timeout=timeout)

    # Set the cell type and content
    new_cell_index = new_cell_count - 1
    await set_cell(page, new_cell_index, cell_type, content, timeout)

    return new_cell_index


async def get_cell(
    page: Page,
    index: int,
    timeout: int = 30000
) -> Locator:
    """Get the cell element at the specified index.

    Similar to Galata's page.notebook.getCell functionality.

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        timeout: Timeout in milliseconds

    Returns:
        Playwright Locator for the cell element
    """
    cells = page.locator('.jp-Cell')
    cell = cells.nth(index)
    await expect(cell).to_be_visible(timeout=timeout)
    return cell


async def select_cell(
    page: Page,
    index: int,
    timeout: int = 30000
):
    """Select a cell at the specified index.

    Similar to Galata's page.notebook.selectCells functionality.

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        timeout: Timeout in milliseconds
    """
    cell = await get_cell(page, index, timeout)
    await cell.click()


async def get_cell_execution_number(
    page: Page,
    index: int,
    timeout: int = 30000
) -> int | None:
    """Get the execution number from a cell's input prompt.

    Extracts the number from the jp-InputArea-prompt element (e.g., "[1]" -> 1).
    Returns None if the cell hasn't been executed or is currently executing ([*]).

    Args:
        page: Playwright page object
        index: Cell index (0-based)
        timeout: Timeout in milliseconds

    Returns:
        Execution number as int, or None if not available
    """
    cell = await get_cell(page, index, timeout)
    prompt = cell.locator('.jp-InputArea-prompt')
    prompt_text = await prompt.text_content()

    if prompt_text is None:
        return None

    # Extract number from brackets, e.g., "[1]" -> "1"
    match = re.search(r'\[(\d+)\]', prompt_text)
    if match:
        return int(match.group(1))

    return None


async def rename_notebook(
    page: Page,
    new_name: str,
    timeout: int = 30000
):
    """Rename the current notebook.

    Uses File > Rename... menu to rename the notebook.

    Args:
        page: Playwright page object
        new_name: New name for the notebook (without .ipynb extension)
        timeout: Timeout in milliseconds
    """
    # Click the "File" menu in the menu bar
    file_menu = page.locator('.lm-MenuBar-itemLabel').filter(has_text=re.compile(r'^File$'))
    await expect(file_menu).to_be_visible(timeout=timeout)
    await file_menu.click()

    # Click "Rename..." in the dropdown menu
    dropdown_menu = page.locator('.lm-Menu.lm-MenuBar-menu')
    await expect(dropdown_menu).to_be_visible(timeout=timeout)
    rename_item = dropdown_menu.locator('.lm-Menu-item[data-command="application:rename"]')
    await expect(rename_item).to_be_visible(timeout=timeout)
    await rename_item.click()

    # Wait for the rename dialog to appear and fill the input
    rename_input = page.locator('.jp-Dialog input')
    await expect(rename_input).to_be_visible(timeout=timeout)
    await rename_input.fill(new_name)

    # Click the Rename button in the dialog
    rename_button = page.locator('.jp-Dialog-button.jp-mod-accept')
    await expect(rename_button).to_be_visible(timeout=timeout)
    await rename_button.click()

    # Wait for the rename to complete
    await page.wait_for_timeout(500)


async def save_notebook(
    page: Page,
):
    """Save the current notebook.

    Uses keyboard shortcut Ctrl+S (or Cmd+S on Mac) to save.

    Args:
        page: Playwright page object
    """
    # Use keyboard shortcut to save
    await page.keyboard.press('ControlOrMeta+S')

    # Wait for save to complete
    await page.wait_for_timeout(1000)


async def delete_file(
    page: Page,
    filename: str,
    timeout: int = 30000
) -> bool:
    """Delete a file from the Jupyter file browser.

    Right-clicks on the file and selects Delete from the context menu.
    Assumes page is on the tree page (/tree).

    Args:
        page: Playwright page object (must be on /tree page)
        filename: Name of the file to delete
        timeout: Timeout in milliseconds

    Returns:
        True if file was deleted, False if file was not found
    """
    # Find the file in the file browser (title starts with "Name: {filename}")
    file_item = page.locator(f'.jp-DirListing-item[data-file-type="notebook"][title^="Name: {filename}"]')

    # Check if file exists
    if await file_item.count() == 0:
        return False

    # Right-click on the file to open context menu
    await file_item.click(button='right')

    # Click "Delete" in the context menu
    context_menu = page.locator('.lm-Widget.lm-Menu')
    await expect(context_menu).to_be_visible(timeout=timeout)
    delete_item = context_menu.locator('.lm-Menu-item[data-command="filebrowser:delete"]')
    await expect(delete_item).to_be_visible(timeout=timeout)
    await delete_item.click()

    # Confirm deletion in the dialog
    delete_button = page.locator('.jp-Dialog-button.jp-mod-accept')
    await expect(delete_button).to_be_visible(timeout=timeout)
    await delete_button.click()

    # Wait for the file to be removed from the list
    await expect(file_item).to_have_count(0, timeout=timeout)

    return True


__all__ = [
    "create_new_notebook",
    "set_cell_type",
    "set_cell",
    "run_cell",
    "run",
    "add_cell",
    "get_cell",
    "select_cell",
    "get_cell_execution_number",
    "rename_notebook",
    "save_notebook",
    "delete_file",
]
