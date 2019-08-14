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
        noDisplayMember(members);
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
      if (intersection(arr, selected_projects).size !== 0 || isGone(member))
        member.classList.add('unselectable-row');
    }
  }

  function isGone(member) {
    const member_name = member.children[0].textContent;
    const selectedRows = document.querySelectorAll('.selected-row');
    const selected_names = Array.from(selectedRows).map(row => row.children[0].textContent);
    const lunches_members = gon.lunches_members;
    for(const lunch_members of lunches_members) {
      const names = lunch_members.map(e => e["real_name"]);
      if (names.some(name => name === member_name) && intersection(names, selected_names).size !== 0)
        return true;
    };
    return false;
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
