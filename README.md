# Pugger Addon

Pugger is a World of Warcraft addon designed to help raid leaders quickly and efficiently announce their raid group status and recruitment needs. The addon provides both a graphical user interface (GUI) and command line options for ease of use.

## Features

- Announce raid group status and recruitment needs.
- Graphical user interface for easy input and announcements.
- Command line support for quick announcements.

## Installation

1. Download the Pugger addon files.
2. Extract the files to your World of Warcraft AddOns directory:
   - `World of Warcraft/_retail_/Interface/AddOns/Pugger`

## Usage

### Graphical User Interface

1. Open the Pugger UI by typing `/puggerui` in the chat.
2. Fill in the raid details:
   - **Raid Name**: The name of the raid you are organizing.
   - **Additional Info**: Any additional information or requirements (e.g., "GS 4500+").
   - **Channel**: The chat channel to send the announcement to (e.g., "YELL", "RAID").
3. Click the **Announce** button to send the announcement.

### Command Line

You can also use the command line to announce raid details:
`/pugger <raidName> <additional> <channel> <channel0>`

- `<raidName>`: The name of the raid you are organizing.
- `<additional>`: Any additional information or requirements.
- `<channel>`: The chat channel to send the announcement to.
- `<channel0>`: (Optional) Additional channel information if needed.

### Example
`/pugger Naxxramas "GS 4500+" YELL`


This command announces that you are looking for members for a Naxxramas raid, requiring a gear score of 4500 or higher, and sends the message to the YELL channel.

## Development

### Functions

- `GetRaidSizeAndDifficulty()`: Determines the raid size and difficulty.
- `AnnounceRaidCount(raidName, additional, channel)`: Announces the raid count and recruitment needs.

### UI Elements

- **Frame**: Main UI frame with a title.
- **Raid Name Input**: Input field for the raid name.
- **Additional Info Input**: Input field for additional information.
- **Channel Input**: Input field for the chat channel.
- **Announce Button**: Button to send the announcement.

### Slash Commands

- `/puggerui`: Opens or closes the Pugger UI.
- `/pugger`: Command line support for announcing raid details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

Thanks to the World of Warcraft API and the community for the resources and support in developing this addon.


