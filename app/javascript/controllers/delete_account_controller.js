import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'passwordInput',
  ]

  /**
   * Resets email input elements. Waits a short period to ensure that inputs are not wiped before being sent to the backend
   */
  confirmDeletion(event) {
    console.log('hi')
    if (!window.confirm('Are you sure you want to delete your account?')) {
      console.log('deleting...')
      event.stopPropagation()
      this.passwordInputTarget.value = ''
    }
  }
}
