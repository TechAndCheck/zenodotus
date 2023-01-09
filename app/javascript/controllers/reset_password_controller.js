import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'passwordLengthText',
    'passwordResetForm',
    'passwordInput',
    'passwordConfirmationInput',
  ]

  connect() {
    console.log('Hello hello', this.elemnt)
  }

  onFormSubmit(event) {
    event.preventDefault()
    console.log('help me please')
  }
}
