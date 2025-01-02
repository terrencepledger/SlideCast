# SlidesCast

SlidesCast is an iOS application that enables users to create and cast slideshows to Google Cast-enabled devices. Designed for ease of use and flexibility, SlidesCast supports local image selection and playback customization.

## Features

- **Google Cast Integration:** Cast images directly to any Google Cast-enabled device.
- **Customizable Slide Duration:** Choose how long each slide is displayed.
- **Shuffle Functionality:** Randomize the order of slides.
- **Looping:** Enable or disable looping for your slideshow.
- **Local Image Server:** Temporarily hosts images locally for efficient casting.
- **Dynamic UI:** Intuitive controls for managing slideshows during playback.

## Requirements

- iOS 14.0 or later
- Xcode 14.0 or later
- Google Cast SDK

## Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/terrencepledger/SlidesCast.git
   cd SlidesCast
   ```

2. Install dependencies using CocoaPods:

   ```bash
   pod install
   ```

3. Open the `SlidesCast.xcworkspace` file in Xcode:

   ```bash
   open SlidesCast.xcworkspace
   ```

4. Configure the project:

   - Set up a Google Cast Developer account.
   - Replace any placeholders with your Google Cast Application ID.

5. Build and run the project on a compatible device or simulator.

## Usage

### Casting Slideshows

1. Launch SlidesCast on your iOS device.
2. Select images to include in your slideshow.
3. Customize playback options such as shuffle, duration, and looping.
4. Connect to a Google Cast device.
5. Tap **Start Slideshow** to begin casting.

### Stopping Playback

- To stop the slideshow, tap the **Stop** button or disconnect from the Cast device.

## Development

### Project Structure

- `SlidesCast/`: The main application source code.
- `SlidesCastTests/`: Unit tests for application components.
- `SlidesCastUITests/`: UI tests for the application.

### Key Components

- **CastManager:** Handles Google Cast sessions, media playback, and remote control commands.
- **LocalServer:** Provides a temporary local HTTP server for serving images.
- **SlideshowOverlay:** A SwiftUI view managing slideshow playback and controls.

### Adding New Features

To extend functionality:

1. Create a new feature branch:

   ```bash
   git checkout -b feature/new-feature
   ```

2. Implement and test your changes.

3. Submit a pull request to the `main` branch.

## Testing

To run unit and UI tests:

1. Open the `SlidesCast.xcworkspace` in Xcode.
2. Select the desired test target (`SlidesCastTests` or `SlidesCastUITests`).
3. Press **Command+U** to execute tests.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork this repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test thoroughly.
4. Submit a pull request with a detailed description of your changes.

## Contact

For questions or feedback, please contact Terrence Pledger via [GitHub Issues](https://github.com/terrencepledger/SlidesCast/issues).

---

Thank you for using SlidesCast! Enjoy creating and casting your slideshows.

