#!/bin/bash

# Define the HTML content
html_content=$(cat <<EOL
<html>
<head>
<style>
body {
  background-color: linen;
  display: flex; 
  align-items: center;
  justify-content: center;
  flex-direction: column;
  height: 100vh;
}

h1 {
  color: maroon;
  display: block;
}
</style>
</head>
  <body>
    <h1>DEPLOY SERVER!</h1>
    <p>all about nothing</p>
  </body>
</html>
EOL
)

# Replace the content of index.html
echo "${html_content}" | sudo tee /var/www/html/index.html

# Restart Nginx
sudo systemctl restart nginx


