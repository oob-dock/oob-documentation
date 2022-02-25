<script>
  export let logs = ['... aguardando resultado'];

  const prettyJsonCode = (obj) => {
    let format = {}

    format.json = {
      replacer: function (_, pIndent, pKey, pVal, pEnd) {
        var key = '<span class=json-key>'
        var val = '<span class=json-value>'
        var str = '<span class=json-string>'
        var r = pIndent || ''
        if (pKey) r = r + key + pKey.replace(/[": ]/g, '') + '</span>: '
        if (pVal) r = r + (pVal[0] == '"' ? str : val) + pVal + '</span>'
        return r + (pEnd || '')
      },
      prettyPrint: function (obj) {
        var jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/gm
        return JSON.stringify(obj, null, 3)
          .replace(/&/g, '&amp;')
          .replace(/\\"/g, '&quot;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(jsonLine, format.json.replacer)
      },
    }

    return format.json.prettyPrint(obj)
  }
</script>

<pre class="logs">
  <code class="json-code">
    {@html prettyJsonCode(logs) }
  </code>
</pre>

<style>
  .logs {
		display: flex;
		flex-direction: column;
    flex: 1;
	}
	.json-code {
		background-color: #282A36;
		color: var(--white-color);
		border-radius: .5rem;
		padding: 10px 20px;
		white-space: pre-wrap;
		width: 100%;
    height: 100%;
		display: block;
		overflow-y: auto;
	}


</style>
