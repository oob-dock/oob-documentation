const React = require('react');

const contentStyle = {
  display: 'flex',
  flexDirection: 'column',
  alignSelf: 'center',
  width: '90%',
  maxWidth: '768px',
};

const DefaultLayout = (props) => {
  return (
    <html>
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <meta name="description" content="Auth Example" />
        <link
          rel="icon"
          href="https://www.opus-software.com.br/wp-content/uploads/2019/01/opus_logo.png"
          type="image/png"
        />
        <title>{props.title || 'Auth'}</title>
        <link rel="stylesheet" href="/global.css" />
      </head>
      <body>
        <div style={contentStyle}>{props.children}</div>
      </body>
    </html>
  );
};

module.exports = DefaultLayout;
