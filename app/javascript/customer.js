$(document).on('change', '#customer_id_field', function() {
  var customerId = $(this).val();
  $.ajax({
    url: '/representatives',
    type: 'GET',
    dataType: 'json',
    data: { customer_id: customerId },
    success: function(data) {
      var representativeSelect = $('#representative_field');
      representativeSelect.empty();
      representativeSelect.append(new Option('-', '')); // 初期値のブランクを追加
      data.representatives.forEach(function(rep) {
        representativeSelect.append(new Option(rep[0], rep[1]));
      });
    },
    error: function(jqXHR, textStatus, errorThrown) {
      alert("Error: " + errorThrown);
    }
  });
});
