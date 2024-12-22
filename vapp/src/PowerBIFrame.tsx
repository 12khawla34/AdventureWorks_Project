const PowerBIFrame = () => {
  return (
    <iframe
      title="DataVisualization"
      width="100%"
      height="100%"
      src="https://app.powerbi.com/reportEmbed?reportId=2e896053-6c3c-4ecc-93a7-3e319e0d6ec6&autoAuth=true&embeddedDemo=true"
      frameBorder="0"
      allowFullScreen={true}
      style={{ 
        border: "none",
        position: "fixed",
        top: 0,
        left: 0,
        right: 0,
        bottom: 0
      }}
    ></iframe>
  );
};

export default PowerBIFrame;
