import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'characterLengthText',
    'passwordResetForm',
    'passwordInput',
    'passwordConfirmationInput',
  ]

  onFormSubmit(event) {
    event.preventDefault()
    console.log("help me please")
  }  
}

