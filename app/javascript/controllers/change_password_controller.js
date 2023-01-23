import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'passwordInput',
    'passwordConfirmationInput',
  ]

  connect() {
    console.log('change password partial controller')
  }

  /**
   * Resets password entry input elements. Waits a short period to ensure that inputs are not wiped before being sent to the backend
   */
  resetPasswordInputs() {
    setTimeout(() => {
      this.passwordInputTarget.value = ''
      this.passwordConfirmationInputTarget.value = ''
    }, 100)
  }
}
