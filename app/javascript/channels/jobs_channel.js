import consumer from './consumer'

consumer.subscriptions.create('JobsChannel', {
  connected() {
    console.log('Connected to jobs channel')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    const jobsStr = JSON.stringify(data.jobs)
    const jobsDiv = document.getElementById('jobs-div')
    if (jobsDiv) { jobsDiv.innerText = jobsStr }
    // Called when there's incoming data on the websocket for this channel
  },
})
