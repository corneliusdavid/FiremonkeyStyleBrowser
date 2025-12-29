# Firemonkey Style Browser

I used to have a tool to view different Firemonkey styles but I couldn't find it anywhere, so wrote my own. This one is written in Delphi 13 Florence but could probably be back-ported without too much difficulty. It allows configuration and saving of three different folders and then fills a listbox with `.style` files found for the selected folder; double+click on the style name to assign that style to the application immediately. The form has several different controls so you can see how they look and operate for that style.

Feel free to modify this project for whatever you need, third-party components, larger form, tabs, etc. If you're using standard components and have an idea for expanded use of this tool, feel free to suggest it or fork and make a pull-request.

## Add to Tools

I found it useful to add this to the Delphi IDE `Tools` menu so when I'm working on a Firemonkey project and get to the point where I need to assign a style, I can use this to help me quickly choose one.

## Screenshot

Here's what it looks like with a style selected:

![Screenshot of app running on Windows](https://github.com/corneliusdavid/FiremonkeyStyleBrowser/blob/main/StyleBrowserScrenshot.png)
