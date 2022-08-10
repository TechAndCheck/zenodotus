import { Controller } from '@hotwired/stimulus'
import consumer from '../channels/consumer';

export default class extends Controller {
  static targets = ['scrapesPill', 'scrapesCount', 'jobsPill', 'jobsCount']

  initialize() {
    this.loadedScrapesCount = Number(this.element.dataset.loadedScrapesCount)
    this.loadedJobsCount = Number(this.element.dataset.loadedJobsCount)
  }

  reloadScrapes() {
    const scrapes = document.getElementById('scrapes')
    const src = scrapes.src
    scrapes.src = null
    scrapes.src = src
    this.scrapesPillTarget.innerText = ''
    this.scrapesPillTarget.hidden = true
  }

  connect() {
    this.jobs_channel = consumer.subscriptions.create('JobsChannel', {
      connected: this._jobsCableConnected.bind(this),
      disconnected: this._jobsCableDisconnected.bind(this),
      received: this._jobsCableReceived.bind(this),
    });

    this.scrapes_channel = consumer.subscriptions.create('ScrapesChannel', {
      connected: this._scrapesCableConnected.bind(this),
      disconnected: this._scrapesCableDisconnected.bind(this),
      received: this._scrapesCableReceived.bind(this),
    });
  }

  _jobsCableConnected() {
    // Called when the subscription is ready for use on the server
    console.log("Jobs Connected...")
  }

  _jobsCableDisconnected() {
    // Called when the subscription has been terminated by the server
  }

  _jobsCableReceived(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received Jobs......." + data)
    const unloadedJobsCount = data["jobs_count"] - this.loadedJobsCount

    this.jobsCountTarget.innerText = data["jobs_count"]
  }

  _scrapesCableConnected() {
    // Called when the subscription is ready for use on the server
    console.log("Scrapes Connected...")
  }

  _scrapesCableDisconnected() {
    // Called when the subscription has been terminated by the server
  }

  _scrapesCableReceived(data) {
    // Called when there's incoming data on the websocket for this channel
    const unloadedScrapesCount = data["scrapes_count"] - this.loadedScrapesCount

    this.scrapesCountTarget.innerText = data["scrapes_count"]

    if(unloadedScrapesCount <= 0){
      this.scrapesPillTarget.hidden = true
      return
    }

    this.scrapesPillTarget.hidden = false
    this.scrapesPillTarget.innerText = unloadedScrapesCount + " new scrapes submitted..."
  }
}
