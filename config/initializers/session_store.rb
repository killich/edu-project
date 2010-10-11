# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_iv-schools_session',
  :secret      => 'b1487961d21380ccf55b84deecbdc9f9def0b948fb058443e474ee3c3f4970c5ee946b3f0e2acd3c24c54689ad800ebfeed86dc7f3384d82cc66a5b3f2088534'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
