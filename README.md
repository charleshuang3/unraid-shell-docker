# Unraid Command-Line Toolbox Docker

With [unRAID-NerdTools](https://github.com/UnRAIDES/unRAID-NerdTools) discontinued, a simple way to install software on Unraid is no longer readily available.
Despite this, using command-line tools remains crucial for server management.

I've found that a simple and effective solution is to launch a Docker container pre-loaded with the necessary command-line tools. This approach offers several
advantages:

*   **Easy Access to Host Files:** It allows you to map specific host paths into the container, enabling seamless access to your server's files. This is
    particularly useful for tasks like modifying configuration files or managing media libraries.
*   **Improved Security:** It provides the ability to lower the user ID within the container. Running containers with a non-root user is a security best
    practice, minimizing potential risks to your host system.

This Docker-based approach provides a flexible and secure way to utilize command-line tools within your Unraid server environment.
