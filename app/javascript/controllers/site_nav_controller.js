import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggleFullNav = (event) => {
    event.preventDefault()
    document.body.classList.toggle('open-site-nav')
  }

  toggleAccountMenu = (event) => {
    event.preventDefault()
    document.getElementById('site-nav__account').classList.toggle('open-account-menu')
  }

  toggleLanguageMenu = (event) => {
    event.preventDefault()
    document.getElementById('site-nav__language').classList.toggle('open-language-menu')
  }
}
