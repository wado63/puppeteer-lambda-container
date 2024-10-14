/**
 * @file lambdaでpuppeteerを動かすだけのサンプル
 */
import { launch } from 'puppeteer'
import { Handler } from 'aws-lambda'
import { globSync } from 'glob'

const executablePath = globSync(
  './chrome-headless-shell/**/chrome-headless-shell'
)[0]

// lambdaはprocessが残り続けるので、browserは共通のものを使いまわす
const browser = await launch({
  headless: 'shell',
  args: [
    '--no-sandbox',
    '--single-process',
    '--disable-gpu',
    '---disable-dev-shm-usage',
  ],
  ...(executablePath && {
    executablePath,
  }),
})

export const handler: Handler = async () => {
  const page = await browser.pages().then((pages) => pages[0])

  await page.goto('https://example.com', { waitUntil: 'load' })

  const h1Text = await page.evaluate(
    () => document.querySelector('h1')?.textContent
  )
  console.log('h1: ', h1Text)
}
