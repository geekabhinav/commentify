/**
 * Created by awkdev on 5/11/2014.
 */
$(function () {
    _500px.init({
        sdk_key: '4b849e2e7c6ccd77420890d4202ec7b4350dd73b'
    });

    _500px.on('authorization_obtained', function () {
        alert('You have logged in');
    });

    _500px.on('logout', function () {
        $('#not_logged_in').show();
        $('#logged_in').hide();
        $('#logged_in').html('');
    });

    // If the user has already logged in & authorized your application, this will fire an 'authorization_obtained' event
    _500px.getAuthorizationStatus();

    // If the user clicks the login link, log them in
    $('#login').click(_500px.login);
});

