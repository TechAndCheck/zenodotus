import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'passwordInput',
    'passwordConfirmationInput',
  ]

  /**
    * Shows the view corresponding to the user's search if they've just loaded a new page
   */
  connect() {
    const url = window.location.href
    if (url.includes('text_search')) {
      document.getElementById('accountSettings').hidden = true
      document.getElementById('textSearchHistory').removeAttribute('hidden')
    } else if (url.includes('image_search')) {
      document.getElementById('accountSettings').hidden = true
      document.getElementById('imageSearchHistory').removeAttribute('hidden')
    }
  }

  /**
   * Toggles the section visible on the accounts page
   */
  toggleView({ params: { id } }) {
    const currentView = [...document.getElementsByClassName('settingsBlock')].filter((i) => i.getAttribute('hidden') == null)[0]
    const newView = document.getElementById(id)
    if (newView === currentView) {
      return
    }
    currentView.setAttribute('hidden', true) // The "true" here is superfluous, but this is shorter than creating an empty attribute
    newView.removeAttribute('hidden')
  }

  deleteAccount(event) {
    const confirmed = window.confirm('Are you sure?')

    if (!confirmed) {
      event.preventDefault()
    }
  }
}
