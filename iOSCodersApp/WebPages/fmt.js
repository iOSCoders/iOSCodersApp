var collapsed = true;
$('body').append('<p/><hr>');
$('body').append('<button name="y">*</div>');

$('[name=z]').css('cursor', 'hand').click(function(){$('.heading').click()});
$('[name=y]').css('cursor', 'hand').click(function(){collapseAll()});

$('.heading').next('.sub-heading').each(function(){
        $(this).prev().css('cursor', 'hand').click(function(){
            $(this).nextUntil('.heading,script').toggle()})});
$('.heading[collapsed="true"]').click();

function collapseAll() {
    $('.heading').each(function(){
        if (collapsed) {
            $(this).next('.sub-heading').hide();
            $(this).nextUntil('.heading,script').hide();
        } else {
            $(this).next('.sub-heading').show();
            $(this).nextUntil('.heading,script').show();
        }
    })
    collapsed = !collapsed;
}
