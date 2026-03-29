# Nvim Guide

## Basics 

leader: " "
file explorer: leader + pv

## Handling windows: 
A window is a viewport on a buffer. In vim to manage windows it is CTRL+w the leading command, that you can follow with several options (in bold those that answer to your question):
- CTRL+w, v: Opens a new vertical split
- CTRL+w, s: Opens a new horizontal split
- CTRL+w, c: Closes a window but keeps the buffer
- CTRL+w, o: Closes other windows, keeps the active window only
- CTRL+w, right arrow: Moves the cursor to the window on the right
- CTRL+w, r: Moves the current window to the right
- CTRL+w, =: Makes all splits equal size

Then, you need to switch the buffers in the windows:
:ls lists all opened buffers
:b5 switches to your 5th buffer


# References
This setup was based on https://www.youtube.com/watch?v=w7i4amO_zaE&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=6
Good introduction to lazy plugin system:
https://lsp-zero.netlify.app/v3.x/tutorial.html

Lazy plugin configuration into files:
https://dev.to/vonheikemen/lazynvim-plugin-configuration-3opi

Python configuration
https://www.playfulpython.com/configuring-neovim-as-a-python-ide/


