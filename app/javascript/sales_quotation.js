document.addEventListener("turbo:load", function() {
  console.log("turbo:load triggered");
  
  // Rows Addition Logic
  const addRowsButton = document.getElementById('addRows');
  let currentRowCount = 0;
  const maxRowsToShowAtOnce = 1;
  const allRows = document.querySelectorAll('.nested-fields');

  allRows.forEach(row => {
    const fields = Array.from(row.querySelectorAll('.form-control')).filter(el => !el.classList.contains('note'));
    const hasInput = fields.some(field => field.value.trim() !== "");
    
    if (hasInput) {
      row.style.display = 'table-row';
      currentRowCount++;
    } else {
      row.style.display = 'none';
    }
  });

  addRowsButton?.addEventListener('click', function() {
    for (let i = currentRowCount; i < currentRowCount + maxRowsToShowAtOnce && i < allRows.length; i++) {
      allRows[i].style.display = 'table-row';
    }
    currentRowCount += maxRowsToShowAtOnce;

    if (currentRowCount >= allRows.length) {
      addRowsButton.style.display = 'none';
    }
  });
  
  // This might still be a hack. Consider identifying the root issue.
  setTimeout(() => {
    addRowsButton?.click();
  }, 100); 
  
  // Customer Selection Logic
  const customerSelect = document.querySelector('.select2-customer');

  if (customerSelect) {
    customerSelect.addEventListener("change", function(event) {
      const customerId = event.target.value;
      if (customerId) {
        fetch(`/customers/${customerId}/representatives.json`)
          .then(response => response.json())
          .then(data => {
            const repSelect = document.querySelector('#sales_quotation_representative_id');
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
          });
      } else {
        const repSelect = document.querySelector('#sales_quotation_representative_id');
        repSelect.innerHTML = '';
        repSelect.disabled = true;
      }
    });
  }
});
