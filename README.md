# Adobe Flash & ActionScript Projects

This repository contains all my Adobe Flash and ActionScript projects. Since Adobe Flash is no longer supported, I am using Ruffle to play SWF files.

## About Ruffle

Ruffle is a Flash Player emulator written in Rust. It allows you to play Flash content directly in your browser without the need for the official Adobe Flash Player. Ruffle uses modern web technologies like HTML5, WebAssembly, and WebGL to emulate Flash content securely and efficiently.

## Projects

- **Stoney Nakoda - Horse Widget**: Click on a part of the horse to hear the name in Stoney Nakoda and learn about horse anatomy!
- **Self Portrait**: Flash Dynamic Spectrograph.
- **Sushi Exam**: Web Authoring Build-It Exam.
- **Environment Exam**: Web Authoring Build-It Exam.

## How to Use

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/flash-as3-projects.git
    ```
2. Open the project folder:
    ```bash
    cd flash-as3-projects
    ```
3. Use Ruffle to play the SWF files:
    - You can use the Ruffle browser extension to play SWF files directly in your browser.
    - Alternatively, you can use the standalone Ruffle application to run SWF files on your local machine.

## Running the Projects

If you encounter the error message "Something went wrong :( It appears you are running Ruffle on the 'file:' protocol," it means that browsers block many features from working for security reasons when using the file protocol.

To resolve this, you can use a dummy server created using Vite. Follow these steps:

1. Install Vite if you haven't already:
    ```bash
    npm install vite
    ```
2. Run the server:
    ```bash
    npm run dev
    ```
3. This will open `index.html` from which you can click on the project you want to navigate to.

## Contributing

Feel free to fork this repository and submit pull requests. Any contributions are welcome!

## License

This repository is licensed under the MIT License. See the LICENSE file for more details.
