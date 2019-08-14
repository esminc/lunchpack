document.addEventListener('turbolinks:load', function() {
  const members = document.querySelectorAll('.member');

  for(const member of members) {
    member.addEventListener('click', function(){
      const forms = document.querySelectorAll('.member-form');
      if (Array.from(forms).every(form => form.value !==''))
        return;

      member.classList.add('selected-row');

      noDisplayMember(members);

      const form = findEmptyForm(forms);
      form.value = member.children[0].textContent;

      form.addEventListener('click', function(){
        form.value = '';
        member.classList.remove('selected-row');
        noDisplayMember();
      });
    });
  }

  // どのメンバーを表示しないか
  function noDisplayMember(members){
    const selectedRows = document.querySelectorAll('.selected-row');
    const selected_projects = Array
      .from(selectedRows)
      .map(row => row.children[1].textContent.split(','))
      .flat()
      .filter(n => n !== '');

    for(const member of members) {
      member.classList.remove('unselectable-row');
      const arr = member.children[1].textContent.split(',');
      if (intersection(arr, selected_projects).size !== 0)
        member.classList.add('unselectable-row');
    }
  }

  function intersection(arr1, arr2){
    const set1 = new Set(arr1);
    const set2 = new Set(arr2);
    return new Set([...set1].filter(e => (set2.has(e))));
  }

  function findEmptyForm(forms) {
    return Array.from(forms).find(form => form.value === '');
  }
});
