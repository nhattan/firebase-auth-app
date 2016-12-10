$ ->
#  firebase.auth().onAuthStateChanged (user) ->
#    if user
#      # User is signed in.
#      user.getToken(true).then (idToken) ->
#        # Send token to your backend via HTTPS
#        console.log idToken
#        window.location = "/auth/firebasetoken/callback?id_token=#{idToken}"
#    else
#      # No user is signed in.

  $('#js-firebase-auth').on 'click', ->
    firebase.auth().signInAnonymously()
    .then (result) ->
      console.log result
      user = firebase.auth().currentUser
      user.getToken(true)
    .then (idToken) ->
      # Send token to your backend via HTTPS
      console.log idToken
      window.location = "/auth/firebasetoken/callback?id_token=#{idToken}"
    .catch (error) ->
      # Handle Errors here.
      console.error(error)

  $('#js-firebase-google-auth').on 'click', ->
    provider = new firebase.auth.GoogleAuthProvider()
    firebase.auth().signInWithPopup(provider)
    .then (result) ->
      console.log result
      user = firebase.auth().currentUser
      user.getToken(true)
    .then (idToken) ->
      # Send token to your backend via HTTPS
      console.log idToken
      window.location = "/auth/firebasetoken/callback?id_token=#{idToken}"
    .catch (error) ->
      # Handle Errors here.
      console.error(error)
