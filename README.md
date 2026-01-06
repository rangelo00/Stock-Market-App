#Stock Market App | Developer Setup Documentation
Overview

This application features a dual-role system for Traders and Admins. It utilizes PostgreSQL for data storage and Tailwind CSS v4 for styling, and Devise for authentication.
1. Environment & Credentials (.env)

The app requires sensitive credentials to handle security handshakes and email notifications. These are stored in a .env file at the project root.

    Action: Create a file named .env in the root folder and add:

Bash

GMAIL_USERNAME=your_email@gmail.com
GMAIL_APP_PASSWORD=your_16_digit_app_password

Essential Google App Password Steps:

    Never use your regular Gmail password; it will result in an SMTPAuthenticationError.

    Go to Google Account > Security > App Passwords.

    Generate a new 16-character code.

    Important: Paste it into .env as one solid string. Remove all spaces and dashes (e.g., abcdclaireefgh NOT abcd-clai-reef-gh).

2. The "Fresh Pull" Workflow

If you have just pulled the code from GitHub or haven't run the app in a while, follow this sequence:

    Update Gems: bundle install.

    Database Reset: bin/rails db:prepare (Ensures migrations are current).

    Clear Old Assets: bin/rails assets:clobber (Removes broken CSS/JS maps).

    Start Server: bin/dev.

3. Creating Admin Accounts

If you cannot log in, do not use the registration form (which may have restricted rules). Use the Rails Console to create a guaranteed user.
Bash

bin/rails c
# Inside the console:
Admin.create!(email: "admin@test.com", password: "password123", password_confirmation: "password123")

4. Troubleshooting Common "Zombie" Errors
"Port 3000 already in use"

If bin/dev fails to start because a previous process didn't die properly, run this "Clean Restart" command:
Bash

fuser -k 3000/tcp && rm -f tmp/pids/server.pid && bin/dev

    fuser -k: Kills the zombie process on port 3000.

    rm -f: Deletes the PID lock file that prevents Rails from booting.

CSS Not Loading

Ensure app/assets/config/manifest.js uses the correct Sprockets syntax.

    Correct: //= link_tree ../images (No space after //).

    Incorrect: // = link_tree ../images (The space breaks the link).
