const addRowsButton = document.getElementById('addRows');
let currentRowCount = 1; // 表示されている行数
const maxRowsToShowAtOnce = 1; // 一度に表示する行数

addRowsButton.addEventListener('click', function() {
  const allRows = document.querySelectorAll('.nested-fields');
  for (let i = currentRowCount; i < currentRowCount + maxRowsToShowAtOnce && i < allRows.length; i++) {
    allRows[i].style.display = 'table-row';
  }
  currentRowCount += maxRowsToShowAtOnce;
  
  // すべての行が表示されている場合、+マークのボタンを隠す
  if (currentRowCount >= allRows.length) {
    addRowsButton.style.display = 'none';
  }
});

addRowsButton.click();
