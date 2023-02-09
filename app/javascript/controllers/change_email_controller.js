import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'emailInput',
    'emailConfirmationInput',
  ]

  /**
   * Resets email input elements. Waits a short period to ensure that inputs are not wiped before being sent to the backend
   */
  resetEmailInputs() {
    setTimeout(() => {
      this.emailInputTarget.value = ''
      this.emailConfirmationInputTarget.value = ''
    }, 100)
  }
}
