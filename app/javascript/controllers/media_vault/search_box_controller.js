import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = [
    'searchBox',
    'searchBoxSpinner',
    'searchByTextForm',
    'searchByTextFieldset',
    'searchByTextField',
    'searchByMediaForm',
    'searchByMediaFieldset',
    'searchByMediaFileInput',
  ]

  searchBoxTargetConnected(element) {
    console.log('searchBoxTargetConnected')

    element.ondragover = (event) => {
      event.preventDefault()
      element.style.opacity = 0.5
    }

    element.ondragenter = (event) => {
      event.preventDefault()
    }

    element.ondragleave = (event) => {
      event.preventDefault()
      element.style.opacity = 1
    }

    element.ondrop = (event) => {
      event.preventDefault()
      element.style.opacity = 1

      if (event.dataTransfer.files.length > 0) {
        this.searchBoxTarget.style.opacity = 0.5
        this.searchBoxSpinnerTarget.style.visibility = 'visible'
        this.searchByMediaFileInputTarget.files = event.dataTransfer.files
        this.switchToMediaMode()
        this.searchByMediaFormTarget.requestSubmit()
      }
    }

    element.onpaste = (event) => {
      console.log('onpaste')
      event.preventDefault()

      this.pasteImage(event)
    }
  }

  async pasteImage(event) {
    console.log('pasteImage')

    this.searchBoxTarget.style.opacity = 0.5
    this.searchBoxSpinnerTarget.style.visibility = 'visible'
    this.searchByMediaFileInputTarget.files = event.clipboardData.files
    this.switchToMediaMode()
    this.searchByMediaFormTarget.requestSubmit()

    // try {
    //   const clipboardContents = await navigator.clipboard.read()
    //   for (const item of clipboardContents) {
    //     if (!item.types.includes("image/png")) {
    //       throw new Error("Clipboard does not contain PNG image data.")
    //     }
    //     const blob = await item.getType("image/png")

    //     this.searchBoxTarget.style.opacity = 0.5
    //     this.searchBoxSpinnerTarget.style.visibility = 'visible'
    //     this.searchByMediaFileInputTarget.files = event.dataTransfer.files
    //     this.switchToMediaMode()
    //     this.searchByMediaFormTarget.requestSubmit()

    //     // destinationImage.src = URL.createObjectURL(blob)
    //   }
    // } catch (error) {
    //   log(error.message)
    // }
  }

  switchToMediaMode() {
    this.searchBoxTarget.classList.add('search-box--media-mode')
    this.searchBoxTarget.classList.remove('search-box--text-mode')
  }

  switchToTextMode() {
    this.searchBoxTarget.classList.add('search-box--text-mode')
    this.searchBoxTarget.classList.remove('search-box--media-mode')
  }

  onMediaSearch(event) {
    if (this.searchByMediaFileInputTarget.files.length === 0) {
      alert('You need to choose an image or video to search by.')
      event.preventDefault()
    } else {
      this.searchBoxTarget.style.opacity = 0.5
      this.searchBoxSpinnerTarget.style.visibility = 'visible'
      this.searchByMediaFormTarget.requestSubmit()
    }
  }

  // See #456 for why we aren't using Turbo here.
}
