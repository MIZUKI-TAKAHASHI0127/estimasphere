document.addEventListener("DOMContentLoaded", function() {
  const addRowsButton = document.getElementById('addRows');
  let currentRowCount = 0;
  const maxRowsToShowAtOnce = 1;

  const allRows = document.querySelectorAll('.nested-fields');

  // 初期ロード時に必須項目が1つ以上入力されている行だけを表示
  allRows.forEach(row => {
    const fields = Array.from(row.querySelectorAll('.form-control')).filter(el => !el.classList.contains('note'));

    const hasInput = fields.some(field => {
      return field.value.trim() !== "";
    });

    if (hasInput) {
      row.style.display = 'table-row';
      currentRowCount++;
    } else {
      row.style.display = 'none';
    }
  });

  addRowsButton.addEventListener('click', function() {
    for (let i = currentRowCount; i < currentRowCount + maxRowsToShowAtOnce && i < allRows.length; i++) {
      allRows[i].style.display = 'table-row';
    }
    currentRowCount += maxRowsToShowAtOnce;

    if (currentRowCount >= allRows.length) {
      addRowsButton.style.display = 'none';
    }
  });
  addRowsButton.click();
});

document.addEventListener("turbo:load", function() {
  const customerSelect = document.querySelector('.select2-customer');
  console.log("Customer select element:", customerSelect);

  if (customerSelect) {
    customerSelect.addEventListener("change", function(event) {
      console.log("Customer selection changed!");
      const customerId = event.target.value;
      if (customerId) {
        fetch(`/customers/${customerId}/representatives.json`)
          .then(response => {
            if (!response.ok) {
              throw new Error("Network response was not ok");
            }
            return response.json();
          })
          .then(data => {
            const repSelect = document.querySelector('#purchase_quotation_representative_id');
            console.log(repSelect); // このログを確認してください。
            repSelect.innerHTML = '';

            const defaultOption = document.createElement("option");
            defaultOption.value = '';
            defaultOption.textContent = '-';
            repSelect.appendChild(defaultOption);

            data.forEach(rep => {
              const option = document.createElement("option");
              option.value = rep.id;
              option.textContent = rep.department_name + " - " + rep.representative_name;
              repSelect.appendChild(option);
            });
          })
          .catch(error => {
            console.error("There was a problem with the fetch operation:", error.message);
          });
      } else {
        const repSelect = document.querySelector('#purchase_quotation_representative_id');
        repSelect.innerHTML = '';
        repSelect.disabled = true;
      }
    });
  }
});