const React = require('react');
const PrettyPrint = require('./components/pretty-print');
const DefaultLayout = require('./layouts/default');

const style = {
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  justifyContent: 'center',
  flex: 1,
};

const Error = ({ title, error, redirectTo }) => {
  const errorMessage = () => {
    if (error) {
      return <PrettyPrint height="40vh" content={error} />;
    }
    return;
  };
  return (
    <DefaultLayout title={title}>
      <div>
        <h1>Erro</h1>
        {errorMessage()}
        <form action={redirectTo} method="post" style={style}>
          <button type="submit">Continuar</button>
        </form>
      </div>
    </DefaultLayout>
  );
};

module.exports = Error;
