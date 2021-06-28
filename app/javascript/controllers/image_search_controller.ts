import { Controller } from 'stimulus'

export default class extends Controller {
  onPostSend() {
    const loader = document.getElementById('loader')
    if (loader !== null) {
      loader.classList.remove('hidden')
    }
  }

  onPostSuccess() {
    console.log('success!')
  }
}
