
# TP-Link Omada Software Controller Installer

This script automates the installation of the TP-Link Omada Software Controller on supported Linux distributions.

## Supported Operating Systems

- **Ubuntu**: 16.04, 18.04, 20.04, 22.04
- **Debian**: 9 (Stretch), 10 (Buster), 11 (Bullseye)
- **CentOS**: 7, 8

## Prerequisites

- The script must be run as root or using `sudo`.

## Usage

1. **Download the Script**

   ```bash
   curl -O https://raw.githubusercontent.com/NOXITB/omada-auto-installer/main/install.sh
   ```

2. **Make the Script Executable**

   ```bash
   chmod +x install.sh
   ```

3. **Run the Script**

   ```bash
   sudo ./install.sh
   ```

## What the Script Does

1. **Verifies Root Privileges**: Ensures the script is run as root.
2. **Verifies Supported OS**: Checks if the operating system is supported.
3. **Installs Prerequisites**:
   - `gnupg`
   - `curl`
   - `wget`
4. **Configures MongoDB Repository and Installs MongoDB 4.4**:
   - Imports the MongoDB GPG key.
   - Adds the MongoDB repository.
   - Installs MongoDB.
5. **Installs Java and JSVC**:
   - Installs OpenJDK 8 JRE (headless).
   - Installs JSVC.
6. **Downloads and Installs Omada Software Controller**:
   - Fetches the latest Omada Software Controller package from TP-Link's website.
   - Installs the package.

## Accessing the Omada Software Controller

After successful installation, access the Omada Software Controller web interface by visiting:

```
https://<your-server-ip>:8043
```

Replace `<your-server-ip>` with the IP address of your server.

## Troubleshooting

- **Script Requires Root**: Ensure you are running the script as root or with `sudo`.
- **Unsupported OS**: The script supports specific versions of Ubuntu, Debian, and CentOS. Make sure your OS version is supported.
- **Network Issues**: Ensure your server has internet access to download necessary packages.

## Contribution

If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/NOXITB/omada-auto-installer).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
