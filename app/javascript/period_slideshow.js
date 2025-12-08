document.addEventListener("turbo:load", () => {
  const containers = document.querySelectorAll("[data-period-slideshow]");
  containers.forEach((container) => {
    const slides = container.querySelectorAll(".period-slide");
    if (slides.length <= 1) return;

    let index = 0;
    slides[index].classList.add("is-active");

    setInterval(() => {
      slides[index].classList.remove("is-active");
      index = (index + 1) % slides.length;
      slides[index].classList.add("is-active");
    }, 4000);
  });
});
