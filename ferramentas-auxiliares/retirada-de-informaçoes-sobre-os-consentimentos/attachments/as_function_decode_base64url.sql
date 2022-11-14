create function decode_base64url(text) returns bytea as $$
  select decode(
    rpad(translate($1, '-_', '+/')   -- pad to the next multiple of 4 bytes
	 ,4*((length($1)+3)/4)
	 ,'=')
    ,'base64');
$$ language sql strict immutable;