document.addEventListener('turbolinks:load', function() {
  $('.tabs').tabs();

  const members = document.querySelectorAll('.member-row');

  for(const member of members) {
    member.addEventListener('click', function(){
      const forms = document.querySelectorAll('.member-form');
      if (Array.from(forms).every(form => form.value !==''))
        return;

      if (!member.classList.contains('unselectable-row')){
        member.classList.add('selected-row');

        noDisplayMember();

        const form = findEmptyForm(forms);
        form.value = member.children[1].textContent;

        form.addEventListener('click', function(){
          form.value = '';
          member.classList.remove('selected-row');
          noDisplayMember(members);
        });
      }
    });
  }

  fillInFirstMemberWithLoginMember();

  function fillInFirstMemberWithLoginMember() {
    for(const member of members) {
      if (member.children[1].textContent === gon.login_member["real_name"])
        member.click();
    }
  }
  

  // どのメンバーを表示しないか
  function noDisplayMember(){
    for(const member of members) {
      member.classList.remove('unselectable-row');
      member.children[0].textContent = '';

      if (hasSameProjects(member) || isUsedBenefitWithSelectedMembers(member)){
        member.classList.add('unselectable-row');
      }
    }
  }

  function hasSameProjects(member) {
    const selectedProjects = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.children[2].textContent.split(','))
      .flat()
      .filter(n => n !== '');
    const memberProjects = member.children[2].textContent.split(',');
    return existsIntersection(memberProjects, selectedProjects);
  }

  function isUsedBenefitWithSelectedMembers(member) {
    const memberName = member.children[1].textContent;
    const selectedNames = Array
      .from(document.querySelectorAll('.selected-row'))
      .map(row => row.children[1].textContent);
    const ns = [];
    for(const trio of gon.lunch_trios) {
      const names = trio.map(e => e["real_name"]);
      for(selectedName of selectedNames) {
        if ((names.includes(memberName)) && (names.includes(selectedName)))
          ns.push(selectedName);
      }
    };
    if (ns.length > 0){
      member.children[0].textContent = `${ns.flat().join(',')}と行ったことがあります。`;
      return true;
    } else {
      return false;
    };
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
