var collapsed = false;
$('body').prepend('<hr>');
$('body').prepend('<center name="y">Expand/Collapse</center>');
$('body').append('<p/><hr>');

$('[name=z]').css('cursor', 'pointer').click(function(){$('.heading').click()});
$('[name=y]').css('cursor', 'pointer').click(function(){collapseAll()});

$('.heading').next('.sub-heading').each(function(){
        $(this).prev().css('cursor', 'pointer').click(function(){
            $(this).nextUntil('.heading,script').toggle()})});
$('.heading[collapsed="true"]').click();

function collapseAll() {
    $('.heading').each(function(){
        if (!collapsed) {
            $(this).next('.sub-heading').hide();
            $(this).nextUntil('.heading,script').hide();
        } else {
            $(this).next('.sub-heading').show();
            $(this).nextUntil('.heading,script').show();
        }
    })
    collapsed = !collapsed;
}
