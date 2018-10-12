import * as en from './en.json'
import * as kr from './kr.json'
import * as app from '../../app.json'

const locales = new Map()

function addLocale(name: string, locale: any) {
  locales.set(name, locale)
}

addLocale('en', en)
addLocale('kr', kr)

const locale: any = locales.get((app as any).locale)

export default locale
