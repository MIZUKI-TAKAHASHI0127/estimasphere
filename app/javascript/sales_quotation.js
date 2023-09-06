document.addEventListener("DOMContentLoaded", function() {
  const addRowsButton = document.getElementById('addRows');
  let currentRowCount = 1; // 表示されている行数
  const maxRowsToShowAtOnce = 1; // 一度に表示する行数

  addRowsButton.addEventListener('click', function() {
    console.log('ボタンがクリックされました'); // クリックが発生したことを確認するためのログ

    const allRows = document.querySelectorAll('.nested-fields');
    for (let i = currentRowCount; i < currentRowCount + maxRowsToShowAtOnce && i < allRows.length; i++) {
      allRows[i].style.display = 'table-row';
      console.log('行を表示しました:', i); // 行を表示したことを確認するためのログ
    }
    currentRowCount += maxRowsToShowAtOnce;
    
    // すべての行が表示されている場合、+マークのボタンを隠す
    if (currentRowCount >= allRows.length) {
      addRowsButton.style.display = 'none';
      console.log('すべての行が表示されました'); // すべての行が表示されたことを確認するためのログ
    }
  });

  addRowsButton.click();
});
