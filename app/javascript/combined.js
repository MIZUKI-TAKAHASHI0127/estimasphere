// 金額を計算する関数
window.calculateAmount = function(row) {
  var quantity = parseFloat(row.find('.quantity').val()) || 0;
  var unitPrice = parseFloat(row.find('.unit_price').val()) || 0;
  console.log('Hello World'); // デバッグ用
  row.find('.amount').text((quantity * unitPrice).toLocaleString());
}

$(document).on('turbolinks:load', function() {

  // 入力フィールドが変更されたときに金額を計算
  $('.quantity, .unit_price').on('input', function() {
    var row = $(this).closest('.nested-fields');
    window.calculateAmount(row);
  });

  $('form').on('click', '.add_fields', function(event) {
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();

    // 新規フィールドの金額計算のための処理を呼び出す
    window.calculateAmount($(this).prev('.nested-fields'));

    return false;
  });

  $('form').on('click', '.remove_fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('.nested-fields').hide();
    event.preventDefault();
    return false;
  });

});
