document.addEventListener("DOMContentLoaded", function() {
  const addRowsButton = document.getElementById('addRows');
  let currentRowCount = 0;
  const maxRowsToShowAtOnce = 1;

  const allRows = document.querySelectorAll('.nested-fields');

  // 初期ロード時に必須項目が1つ以上入力されている行だけを表示
  allRows.forEach(row => {
    const fields = Array.from(row.querySelectorAll('.form-control')).filter(el => el.className !== 'form-control note');  // note クラスを持つ要素は除外

    const hasInput = fields.some(field => {
      return field.value.trim() !== "";
    });

    if (hasInput) {
      row.style.display = 'table-row';
      currentRowCount++; // 表示されている行数を増やす
    } else {
      row.style.display = 'none'; // 必須項目がすべて空の場合は非表示
    }
  });

  addRowsButton.addEventListener('click', function() {
    console.log('ボタンがクリックされました');

    for (let i = currentRowCount; i < currentRowCount + maxRowsToShowAtOnce && i < allRows.length; i++) {
      allRows[i].style.display = 'table-row';
      console.log('行を表示しました:', i + 1);
    }
    currentRowCount += maxRowsToShowAtOnce;

    if (currentRowCount >= allRows.length) {
      addRowsButton.style.display = 'none';
      console.log('すべての行が表示されました');
    }
  });
});
