import './style.css';
import ruffleLogo from '/ruffle.svg';

const listItems = [
  {
    title: "Stoney Nakoda - Horse Widget",
    link: "./horse-widget.html",
    description: "Click on a part of the horse to hear the name in Stoney Nakoda and learn about horse anatomy! This interactive feature is brought to you by the Stoney Education Authority."
  }
];

document.querySelector('#app').innerHTML = `
  <div>
    <a href="https://ruffle.rs" target="_blank">
      <img src="${ruffleLogo}" class="logo" alt="Ruffle logo" />
    </a>
    <h1>Hello Ruffle!</h1>
    <p class="read-the-docs">
      Click on the Ruffle logo to learn more
    </p>
    <ol>
      ${listItems.map(item => `
        <li>
          <a href="${item.link}">${item.title}</a>
          <p class="read-the-docs">${item.description}</p>
        </li>
      `).join('')}
    </ol>
  </div>
`;
