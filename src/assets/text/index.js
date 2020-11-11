/* eslint-disable import/no-webpack-loader-syntax */
import en from '!!raw-loader!./en.md'
import marked from 'marked'
import { sanitize } from 'dompurify'

const lang = {
  en: {
    text: en,
    name: 'English'
  }
}

export const text = Object.fromEntries(Object.keys(lang).map(l => [l, parse(lang[l].text)]))
export const languages = Object.keys(lang).map(l => {
  return {
    name: lang[l].name,
    path: l === 'en' ? '/' : `/${l}`,
    code: l
  }
})

function parse (text) {
  const sections = text.split('+++').filter((d, i) => i > 0).map(t => {
    return [
      t.trim().match(/^[^\s]*/)[0],
      sanitize(
        marked(
          t.trim()
            .replace(/^[^\n]*/, '')
            .trim()
            .replace()
            .replace(/@([^(]+)\(([^)]+)\)/g, (a, b, c) => `<span class="keyword ${b}">${c}</span>`)
        )
      ).replace(/(href="https?:\/\/)/g, (a, b) => `target="blank" ${b}`)
    ]
  })
  const keys = [...new Set(sections.map(s => s[0]))]
  return Object.fromEntries(keys.map(k => {
    return [k, sections.filter(s => s[0] === k).map(s => s[1])]
  }))
}
