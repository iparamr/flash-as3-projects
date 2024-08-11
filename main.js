import './style.css'
import ruffleLogo from '/ruffle.svg'

document.querySelector('#app').innerHTML = `
  <div>
    <a href="https://ruffle.rs" target="_blank">
      <img src="${ruffleLogo}" class="logo" alt="Ruffle logo" />
    </a>
    <h1>Hello Ruffle!</h1>
    <p class="read-the-docs">
      Click on the Ruffle logo to learn more
    </p>
  </div>
`
