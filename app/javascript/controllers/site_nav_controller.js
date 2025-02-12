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
    console.log(document.getElementById('site-nav__language-menu').classList)
    document.getElementById('site-nav__language-menu').classList.toggle('close-language-menu')
    document.getElementById('site-nav__language-menu').classList.toggle('open-language-menu')
  }
}
