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

  fillInFirstMemberWithLoginMember();

  function fillInFirstMemberWithLoginMember() {
    for(const member of members) {
      if (member.children[0].textContent === gon.login_member["real_name"])
        member.click();
    }
  }
  

  // どのメンバーを表示しないか
  function noDisplayMember(members){
    for(const member of members) {
      member.classList.remove('unselectable-row');
      if (hasSameProjects(member) || isUsedBenefitWithSelectedMembers(member))
        member.classList.add('unselectable-row');
    }
  }

  function hasSameProjects(member) {
    const selectedProjects = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.children[1].textContent.split(','))
      .flat()
      .filter(n => n !== '');
    const memberProjects = member.children[1].textContent.split(',');
    return existsIntersection(memberProjects, selectedProjects);
  }

  function isUsedBenefitWithSelectedMembers(member) {
    const memberName = member.children[0].textContent;
    const selectedNames = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.children[0].textContent);
    for(const trio of gon.lunch_trios) {
      const names = trio.map(e => e["real_name"]);
      if (names.some(name => name === memberName) && existsIntersection(names, selectedNames))
        return true;
    };
    return false;
  }

  function existsIntersection(arr1, arr2){
    const set1 = new Set(arr1);
    const set2 = new Set(arr2);
    const intersection =  new Set([...set1].filter(e => (set2.has(e))));
    return intersection.size !== 0;
  }

  function findEmptyForm(forms) {
    return Array.from(forms).find(form => form.value === '');
  }
});
