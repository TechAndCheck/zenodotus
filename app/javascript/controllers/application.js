import { Application } from '@hotwired/stimulus'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// This is the way Rails + Stimulus expect it to work.
// eslint-disable-next-line import/prefer-default-export
export { application }
