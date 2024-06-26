import { expect, test } from '@playwright/test';
import { execSync } from 'child_process';

test.beforeAll(() => {
  // Dockerコンテナを起動
  execSync('docker run -d --name jupyter_lab_container -p 8888:8888 niicloudoperation/notebook start-notebook.sh --NotebookApp.token="" --NotebookApp.password=""');
});

test.afterAll(() => {
  // Dockerコンテナを停止
  execSync('docker stop jupyter_lab_container');
  execSync('docker rm jupyter_lab_container');
});

function delay(ms: number) {
  // https://stackoverflow.com/questions/37764665/how-to-implement-sleep-function-in-typescript
  return new Promise( resolve => setTimeout(resolve, ms) );
}

test.setTimeout(90000);
test('should emit an activation console message', async ({ page }) => {
  const logs: string[] = [];

  page.on('console', message => {
    logs.push(message.text());
  });

  // docker上のJupyter Labが起動するまで待機
  const timeout = 30000;
  let startDate = Date.now();
  while(true) {
    await delay(1000);
    // タイムアウトのチェック
    if(Date.now() - startDate >= timeout) {
      console.log("wait for docker: timeout!");
      break;
    }

    try {
      let response = await page.goto('');
      if(response && response.status() == 200) {
        console.log("wait for docker: finished.");
        break;
      }
    } catch (e) {
      console.log(`network error: ${e.message}`);
    }
    console.log("wait for docker: continue...");
  }

  // ログの待機
  const log_lc_index = 'JupyterLab extension lc_index is activated!';
  const log_lc_multi_outputs = 'JupyterLab extension lc_multi_outputs is activated!';
  const log_lc_notebook_diff = 'JupyterLab extension lc_notebook_diff is activated!';
  const log_lc_run_through = 'JupyterLab extension lc_run_through is activated!';
  const log_nblineage = 'JupyterLab extension nblineage is activated!';
  startDate = Date.now();
  while(true) {
    await delay(100);
    // タイムアウトのチェック
    if(Date.now() - startDate >= timeout) {
      console.log("wait for docker: timeout!");
      break;
    }

    if(
      logs.filter(s => s === log_lc_index).length == 1 &&
      logs.filter(s => s === log_lc_multi_outputs).length == 1 &&
      logs.filter(s => s === log_lc_notebook_diff).length == 1 &&
      logs.filter(s => s === log_lc_run_through).length == 1 &&
      logs.filter(s => s === log_nblineage).length == 1
    ) {
      console.log("wait for docker: finished.");
      break;
    }
    console.log("wait for log: continue...")
  }
  
  // lc_index
  expect(
    logs.filter(s => s === log_lc_index)
  ).toHaveLength(1);
  
  // lc_multi_outputs
  // console.debug
  expect(
    logs.filter(s => s === log_lc_multi_outputs)
  ).toHaveLength(1);

  // lc_notebook_diff
  expect(
    logs.filter(s => s === log_lc_notebook_diff)
  ).toHaveLength(1);
  
  // lc_run_through
  // console.debug
  expect(
    logs.filter(s => s === log_lc_run_through)
  ).toHaveLength(1);

  // nblineage
  expect(
    logs.filter(s => s === log_nblineage)
  ).toHaveLength(1);

  // nbsearch(disabled)
  // nbwhisper(disabled)
  // sidestickies(disabled)
});