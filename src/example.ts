/**
 * @file puppeteerを動かすだけのサンプル
 */
import { launch } from 'puppeteer'
import { globSync } from 'glob'

const executablePath = globSync(
  './chrome-headless-shell/**/chrome-headless-shell'
)[0]
;(async () => {
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

  const page = await browser.pages().then((pages) => pages[0])

  await page.goto('https://example.com', { waitUntil: 'load' })

  const h1Text = await page.evaluate(
    () => document.querySelector('h1')?.textContent
  )
  console.log('h1: ', h1Text)

  await browser.close()
})()
