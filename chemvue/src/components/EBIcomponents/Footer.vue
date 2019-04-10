<template>
  <footer>
    <div id="global-footer" class="global-footer">
      <nav id="global-nav-expanded" class="global-nav-expanded row">
        <!-- Footer will be automatically inserted by footer.js -->
      </nav>
      <section id="ebi-footer-meta" class="ebi-footer-meta row">
        <!-- Footer meta will be automatically inserted by footer.js -->
      </section>
    </div>
  </footer>
</template>

<script>
export default {
  name: "EBIFooter",
  mounted() {
    // eslint-disable-next-line
    ebiFrameworkUpdateFoot();
    // eslint-disable-next-line
    ebiFrameworkUpdateFooterMeta();
  }
};
</script>

<style scoped></style>
