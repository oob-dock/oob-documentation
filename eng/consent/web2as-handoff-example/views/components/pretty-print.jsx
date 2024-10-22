const React = require('react');
const JSONPretty = require('react-json-pretty');
var JSONTheme = require('react-json-pretty/dist/acai');

const PrettyPrint = ({ content, height }) => {
  const style = {
    maxHeight: height || '100%',
    width: '100%',
    overflow: 'auto',
    fontSize: '0.8em',
  };
  return (
    <JSONPretty
      style={style}
      data={content}
      onJSONPrettyError={(e) => console.error(e)}
      theme={JSONTheme}
    ></JSONPretty>
  );
};

module.exports = PrettyPrint;
