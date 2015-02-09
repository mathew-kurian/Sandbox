var nodemailer = require('nodemailer');

// create reusable transport method (opens pool of SMTP connections)
var smtpTransport = nodemailer.createTransport("SMTP",{
    service: "Gmail",
    auth: {
        user: "brent.mus.ec@gmail.com",
        pass: "i am king yo"
    }
});

exports.sendConfirmationEmail = function(email, confirmToken) {

    var activationLink = 'https://mus.ec/verify/' + confirmToken;

    var htmlMsg = '<div style="font-size:16px"><b>Welcome to Mus.ec!</b></div>' +
                    '<br>' +
                    '<div>Please confirm your email below:</div>' +
                    '<div><a href=' + activationLink + '>Activate my account</a></div>' +
                    '<br>' +
                    '<div style="font-size:12px">Note: This link will expire in 10 minutes. Please register again if it becomes invalid.</div>';

    var mailOptions = {
        from: "Brent Enriquez <brent.mus.ec@gmail.com>", 
        to: email, 
        subject: "Registration Confirmation for Mus.ec", 
        html: htmlMsg 
    }

    // Send email.
    smtpTransport.sendMail(mailOptions, function(error, response){
        if(error){
            console.log(error);
        }else{
            console.log("Message sent: " + response.message);
        }

    });

}

exports.sendResetPasswordEmail = function(email, resetToken) {

    var resetLink = 'https://mus.ec/reset/' + resetToken;

    var htmlMsg = '<div style="font-size:16px"><b>Password reset for Mus.ec</b></div>' +
                    '<br>' +
                    '<div>Please click the link below to reset your password:</div>' +
                    '<div><a href=' + resetLink + '>Reset my password</a></div>';

    mailOptions = {
        from: "Brent Enriquez <brent.mus.ec@gmail.com>", // sender address
        to: email, // list of receivers
        subject: "Reset password request for Mus.ec", // Subject line
        html: htmlMsg // html body
    }

    smtpTransport.sendMail(mailOptions, function(error, response){
        if(error){
            console.log(error);
        }else{
            console.log("Message sent: " + response.message);
        }
    });  

}



