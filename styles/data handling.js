// Helper function to collect form data
function collectFormData() {
    const garedepart = document.querySelector('.depart').value.trim();
    const garearrivee = document.querySelector('.arrivee').value.trim();
    const datedep = document.getElementById('datedep').value.trim();
    const dateretoure = document.getElementById('dateretoure').value.trim();
    const typevoy = document.getElementById('typevoy').value.trim();

    if (!garedepart || !garearrivee || !datedep || !typevoy) {
        alert('All required fields must be filled!');
        console.error('Form validation failed: Missing required fields.');
        return null;
    }

    console.log('Form data collected:', { garedepart, garearrivee, datedep, dateretoure, typevoy });
    return {
        garedepart,
        garearrivee,
        datedep,
        dateretoure: dateretoure || 'N/A',
        typevoy
    };
}

// Save form data to localStorage and redirect if trains are available
async function saveDataAndRedirect() {
    const tripData = collectFormData();
    if (tripData) {
        try {
            localStorage.setItem('tripData', JSON.stringify(tripData));
            console.log('Data saved to localStorage:', tripData);

            // Simulate checking for available trains
            const trainsAvailable = await checkAvailableTrains(tripData);

            if (trainsAvailable) {
                window.location.href = "available-trains.html"; // Redirect to the trains page
            } else {
                alert('No trains available for the selected time and route.');
            }
        } catch (error) {
            console.error('Error saving to localStorage:', error);
            alert(' inexpected error  Please try again.');
        }
    }
}

// Handle form submission
document.addEventListener('DOMContentLoaded', function () {
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function (event) {
            event.preventDefault(); // Prevent default form submission
            saveDataAndRedirect(); // Collect, save data, and redirect
        });
        console.log('Form submission handler attached.');
    } else {
        console.error('Booking form not found.');
    }
});

// Simulate checking for available trains
async function checkAvailableTrains(tripData) {
    console.log('Checking for available trains with trip data:', tripData);

    // Simulate a delay for checking train availability
    return new Promise((resolve) => {
        setTimeout(() => {
            const isAvailable = Math.random() > 0.2; // 80% chance of trains being available
            resolve(isAvailable);
        }, 2000); // Simulate a 2-second delay
    });
}